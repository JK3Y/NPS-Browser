//
//  ToolbarDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//
import RealmSwift

protocol ToolbarDelegate {
    func setArrayControllerContent(content: Results<Item>?)
    
//    func filterByRegion(region: String)
    
    func filterType(itemType: ItemType, region: String)
    
    func filterString(itemType: ItemType, region: String, searchString: String)
}
