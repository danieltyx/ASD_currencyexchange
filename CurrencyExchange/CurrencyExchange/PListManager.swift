//
//  PListManager.swift
//  Browser
//
//  Created by lake on 12/2/20.
//

import UIKit

class PListManager: NSObject
{
    
    //All About Dictionaries
    /*
       Project Tasks
       1. Populate the picker views with all the currencies accepted in the supportedPairs.
       2. Display each currency exchange search results (ONLY supportedPairs).
       3. Create a plist history of all currency exchange searches with timestamp.
       4. Create a view that displays the above history.
       5. Add the funtionality that can perform currency exchanges that are not listed in the pairs. Use math and two different pairs
          to calculate the exchange rate by going through the USD. For example, CADEUR is not listed in the pairs but USDCAD and USDEUR are
          listed. Therefore a CADEUR search should use the two searches (USDCAD and USDEUR) and some math to figure out the exchange.
       6. It's a competition so add any functionality that enhances the app.
     
        Happy Coding :-)
     */
    
    
    
    //Writing to the document directory
    func writePlist(namePlist: String, key: String, data: AnyObject)
    {
        let path = self.findPath(namePlist: namePlist)
        if let dict = NSMutableDictionary(contentsOfFile: path)
        {
            
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true)
            {
                print("plist_write")
                print(dict)
            }
            else
            {
                print("1. plist_write_error")
            }
        }
        else
        {
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist")
            {
                if let dict = NSMutableDictionary(contentsOfFile: privPath)
                {
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true)
                    {
                        print("plist_write")
                    }
                    else
                    {
                        print("2. plist_write_error")
                    }
                }
                else
                {
                    print("plist_write")
                }
            }
            else
            {
                print("error_find_plist")
            }
        }
    }

    
    //Reading from document directory
    func readPlist(namePlist: String, key: String) -> AnyObject
    {
        let path = self.findPath(namePlist: namePlist)
        var output:AnyObject = false as AnyObject
        
        if let dict = NSMutableDictionary(contentsOfFile: path)
        {
            output = dict.object(forKey: key)! as AnyObject
        }
        else
        {
            output = self.performMainBundleRead(namePlist: namePlist, key: key)
        }
        print("plist_read \(output)")
        return output
    }
    
    
    //delete all data in document directory
    func deleteAllData()
    {
        let path = self.findPath(namePlist: "EmptyList")
        if let privPath = Bundle.main.path(forResource: "EmptyList", ofType: "plist")
        {
            if let dict = NSMutableDictionary(contentsOfFile: privPath)
            {
                if dict.write(toFile: path, atomically: true)
                {
                    print("plist_write")
                }
                else
                {
                    print("2. plist_write_error")
                }
            }
            else
            {
                print("plist_write")
            }
        }
        
    }
    

    //Reading all data from the main bundle
    func readAllPlistFromMainBundle(namePlist: String) -> AnyObject
    {
        return self.performMainBundleRead(namePlist: namePlist, key: "")
    }
    
    //Reading specific data from the main bundle
    func readPlistFromMainBundle(namePlist: String, key: String) -> AnyObject
    {
        return self.performMainBundleRead(namePlist: namePlist, key: key)
    }
    
    
    
    //Helpoer method to find the path of the plist on the document directory
    private func findPath(namePlist: String) -> String
    {
      
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        return path
    }
    
    
    //Helper method to read from the main bundle
    private func performMainBundleRead(namePlist: String, key: String) -> AnyObject
    {
        var output:AnyObject = false as AnyObject
        
        if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist")
        {
            if let dict = NSMutableDictionary(contentsOfFile: privPath)
            {
                if key.isEmpty
                {
                    output = dict
                }
                else
                {
                    output = dict.object(forKey: key)! as AnyObject
                }
                
            }
            else
            {
                output = false as AnyObject
                print("error_read")
            }
        }
        else
        {
            output = false as AnyObject
            print("error_read")
        }
        
        return output
    }
    

}

extension String
{
    
     //Finds the substring in a valid range
      public func getSubString( _ from: Int, _ to: Int) -> String
      {
          
          let start = self.index(self.startIndex, offsetBy: from)

          let end = self.index(self.startIndex, offsetBy: to)
     
          return String(self[start..<end])
      }
}
