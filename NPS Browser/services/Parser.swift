//
//  Parser.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import SWXMLHash

class Parser {
    func parseTSV(data: String, type: String) -> [NPSBase] {
        var parsedData = [NPSBase]()
        var rows = data.split(separator: "\r\n")
        rows.remove(at: 0)
        
        for row in rows {
            let values = row.components(separatedBy: "\t")
            let tsvdata = TSVData(type: type, values: values)
            parsedData.append(tsvdata.makeNPSObject())
        }
        return parsedData
    }
    
    func parseCompatPackEntries(data: String, isPatch: Bool = false) -> [CompatPack] {
        var parsedData = [CompatPack]()
        let rows = data.split(separator: "\n")
        
        for row in rows {
            let baseURL = "https://gitlab.com/nopaystation_repos/nps_compati_packs/raw/master/"
            let components = row.components(separatedBy: "=")
            let path = components.first ?? ""
            var title_id: String
            if (isPatch) {
                title_id = path.components(separatedBy: "/")[1]
            } else {
                title_id = path.components(separatedBy: "/")[0]
            }
            
            let url: URL? = URL(string: "\(baseURL)\(path)")
            let pack = CompatPack(id: title_id, download_url: url!)
            
            parsedData.append(pack)
        }
        return parsedData
    }
    
    func parseUpdateXML(data: String) -> URL? {
        guard let xml = try? SWXMLHash.parse(data) else {
            return nil
        }
        
        let subindexer = xml["titlepatch"]["tag"]
        
        guard let lastpkg = subindexer.children.last else {
            return nil
        }

        var x: String?
        
        do {
            x = try? lastpkg.byKey("hybrid_package").element?.attribute(by: "url")?.text as! String
            
            if (x == nil) {
                x = try lastpkg.element?.attribute(by: "url")?.text
            }
        } catch {
            log.error(error)
        }
        
        return URL(string: x!)
    }
}