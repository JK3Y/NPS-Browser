//
//  Settings.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Foundation

class SettingsViewController: NSViewController {
    @IBOutlet weak var psvgField: NSTextField!
    @IBOutlet weak var psvuField: NSTextField!
    @IBOutlet weak var psvdlcField: NSTextField!
    @IBOutlet weak var psxgField: NSTextField!
    @IBOutlet weak var pspgField: NSTextField!
    @IBOutlet weak var dlPathField: NSTextField!
    @IBOutlet weak var chkExtractPKG: NSButton!
    @IBOutlet weak var chkCreateLicense: NSButton!
    @IBOutlet weak var chkKeepPKG: NSButton!
    @IBOutlet weak var chkSaveZip: NSButton!
    @IBOutlet weak var chkCompressPSPISO: NSButton!
    @IBOutlet weak var compressionFactorStepper: NSStepper!
    @IBOutlet weak var compressionFactorField: NSTextField!
    
    var dlLocation: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = SettingsManager().getSettings()
        updateTextFields(settings: settings!)
    }
    
    @IBAction func toggleCompressionFactor(_ sender: NSButton) {
        switch sender.state {
        case .on:
            compressionFactorStepper.isEnabled = true
            compressionFactorField.isEnabled = true
            break
        case .off :
            compressionFactorStepper.isEnabled = false
            compressionFactorField.isEnabled = false
            break
        default:
            break
        }
    }
    
    @IBAction func stepCompressionFactor(_ sender: Any) {
        compressionFactorField.integerValue = compressionFactorStepper.integerValue
    }
    
    func updateTextFields(settings: Settings) {
        
        self.dlLocation = settings.download.download_location
        
        psvgField.stringValue   = settings.source.psv_games?.absoluteString ?? ""
        psvuField.stringValue   = settings.source.psv_updates?.absoluteString ?? ""
        psvdlcField.stringValue = settings.source.psv_dlc?.absoluteString ?? ""
        psxgField.stringValue   = settings.source.psx_games?.absoluteString ?? ""
        pspgField.stringValue   = settings.source.psp_games?.absoluteString ?? ""
        
        dlPathField.stringValue = self.dlLocation!.path

        chkExtractPKG.state     = settings.extract.extract_after_downloading ? .on : .off
        chkKeepPKG.state        = settings.extract.keep_pkg ? .on : .off
        chkSaveZip.state        = settings.extract.save_as_zip ? .on : .off
        chkCreateLicense.state  = settings.extract.create_license ? .on : .off
        chkCompressPSPISO.state = settings.extract.compress_psp_iso ? .on : .off
        
        compressionFactorField.integerValue     = settings.extract.compression_factor
        compressionFactorStepper.integerValue   = settings.extract.compression_factor
    }
    
    @IBAction func selectDLPath(_ sender: Any) {
        guard let window = view.window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                self.dlLocation = panel.urls[0]
                self.dlPathField.stringValue = self.dlLocation!.path
            }
        }
    }
    
    @IBAction func resetToDefaults(_ sender: Any) {
        updateTextFields(settings: SettingsManager().getDefaultSettings())
    }
    
    @IBAction func save(_ sender: Any) {

        let source      = SourceSettings(psv_games: psvgField.stringValue,
                                         psv_dlc: psvdlcField.stringValue,
                                         psv_updates: psvuField.stringValue,
                                         psp_games: pspgField.stringValue,
                                         psx_games: psxgField.stringValue)
        let download    = DownloadSettings(download_location: self.dlLocation!.absoluteURL,
                                           concurrent_downloads: 3)
        let extract     = ExtractSettings(extract_after_downloading: chkExtractPKG.state == .on,
                                          keep_pkg: chkKeepPKG.state == .on,
                                          save_as_zip: chkSaveZip.state == .on,
                                          create_license: chkCreateLicense.state == .on,
                                          compress_psp_iso: chkCompressPSPISO.state == .on,
                                          compression_factor: compressionFactorField.integerValue)
        
        let settings = Settings(source: source, download: download, extract: extract)
        SettingsManager().setSettings(settings: settings)
        
        dismissViewController(self)
    }
}
