//
//  Binding.swift
//  AppLog
//
//  Created by Apple on 28/11/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//

import Foundation
import CoreData

enum  basicDateformat : String
{
    case
    simple                 = "yyyy-MM-dd hh:mm:ss Z",
    
    a = "EEEE, MMM d, yyyy", // Monday, Nov 28, 2016
    b = "MM/dd/yyyy",     // 11/28/2016
    c = "MM-dd-yyyy HH:mm", // 11-28-2016 03:49
    d = "MMM d, H:mm a", // Nov 28, 3:49 AM
    e = "MMMM yyyy", // November 2016
    f = "MMM d, yyyy", // Nov 28, 2016
    g = "E, d MMM yyyy HH:mm:ss Z", //Mon, 28 Nov 2016 03:49:20 -0500
    h = "yyyy-MM-dd'T'HH:mm:ssZ", // 2016-11-28T03:49:20-0500
    i = "dd.MM.yy" // 28.11.16
    
    
   
  
    
}

// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(self[position ..< endIndex])
        return result
    }
}

extension NSManagedObject {

    /* bind  Defination :- This function will automatically set value to Dictionary
     
     Note: keys of dictionary should be same to Entity Attributes
     */
    
    func dataBinding( dictionary : Dictionary<  String, Any>? ,  dateformat : String  )
    {
        if dictionary == nil
        {
            return
        }
        
        let attributes = self.entity.attributesByName
        
        for attribute   in attributes
        {
            
            var value = dictionary?["\(attribute.key)"]
            
            if value == nil
            {
                continue
            }
            
            let attributeType = attributes["\(attribute.key)"]?.attributeType

            
            if ((attributeType == NSAttributeType.stringAttributeType)  && ((value as? String) != nil) )
            {
                
                
                value = (value! as! String).stringByDecodingHTMLEntities;
            }
            else  if ((attributeType == NSAttributeType.stringAttributeType)  && ((value as? NSNumber) != nil) )
            {
                
                
                value = String(describing: value!).stringByDecodingHTMLEntities;
                
            }
            else  if ((attributeType == NSAttributeType.booleanAttributeType)  && ((value as? NSNumber) != nil) )
            {
                
                
                value = value as! Bool
                
                
            }
            else  if ((attributeType == NSAttributeType.integer16AttributeType)  ||
                (attributeType == NSAttributeType.integer32AttributeType)  ||
                (attributeType == NSAttributeType.integer64AttributeType)  &&
               ((value as? NSNumber) != nil)
                )
            {
    
                if let myNumber = NumberFormatter().number(from: value as! String)
                {
                    value = myNumber.intValue
                    // do what you need to do with myInt
                } else {
                    value =  attribute.value.defaultValue!
                    // what ever error code you need to write
                }
                
            
                value  = value!
                
            }
                
                
            else  if ((attributeType == NSAttributeType.integer16AttributeType)  ||
                (attributeType == NSAttributeType.integer32AttributeType)  ||
                (attributeType == NSAttributeType.integer64AttributeType)  ||
                (attributeType == NSAttributeType.booleanAttributeType)  &&
                ((value as? String) != nil)
                )
            {
                if let myNumber = NumberFormatter().number(from: value as! String)
                {
                    value = myNumber.intValue
                    // do what you need to do with myInt
                } else {
                    value =  attribute.value.defaultValue!
                    // what ever error code you need to write
                }
                
            }
                
            else  if ((attributeType == NSAttributeType.floatAttributeType)  &&
                ((value as? Float) != nil)
                )
            {
                print("\(attributeType)")
                
                
                value  = value!
                
            }
               
            else  if ((attributeType == NSAttributeType.floatAttributeType)  &&
                ((value as? String) != nil)
                )
            {
                print("\(attributeType)")
                
                
              
                
                if let myNumber = NumberFormatter().number(from: value as! String)
                {
                    value = myNumber.floatValue
                    // do what you need to do with myInt
                } else {
                    value =  attribute.value.defaultValue!
                    // what ever error code you need to write
                }
            }
            else    if ((attributeType == NSAttributeType.dateAttributeType)  && ((value as? String) != nil) )
            {
                 value = stringToDate(dateStg: value! as! String, format: dateformat)
                
            }
            else  if ((attributeType == NSAttributeType.dateAttributeType)  && ((value as? NSDate) != nil) )
            {
                value = value!
            }
            self.setValue(value! , forKey: attribute.key)
  
        }
   
    }
    
    func stringToDate(dateStg : String , format : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let myDate = dateFormatter.date(from: dateStg)
        return myDate!
    }
    
    
    
    
}
