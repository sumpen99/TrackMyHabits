//
//  FileHandler.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-24.
//

import SwiftUI


class FileHandler{
    
    static func getDocumentsUrl() -> NSURL?{
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
    }
    
    static func getFileNameUrl(_ filename:String) -> URL?{
        guard let documentsUrl = getDocumentsUrl() else {
            return nil
        }
        return documentsUrl.appendingPathComponent(filename)
    }
    
    static func getAbsoluteFileNamePath(_ filename:String) -> String?{
        guard let documentsUrl = getDocumentsUrl(),let docString = documentsUrl.absoluteString else {
            return nil
        }
        return URL(fileURLWithPath: docString).appendingPathComponent(filename).path
    }
    
    static func removeFileFromDocuments(_ fileName:String,
                                        onFinishWriting : ((ThrowableResult) -> Void)? = nil){
        var throwableResult = ThrowableResult()
        guard let fileNameUrl = getFileNameUrl(fileName) else {
            throwableResult.value = "Unable to get directorypath as NSURL"
            throwableResult.finishedWithoutError = false
            onFinishWriting?(throwableResult)
            return
         }
        do {
            try FileManager.default.removeItem(at: fileNameUrl)
            throwableResult.value = "Successfully removed image from path \(fileNameUrl)"
            throwableResult.finishedWithoutError = true
        } catch  {
            throwableResult.value = error.localizedDescription
            throwableResult.finishedWithoutError = false
            
        }
        onFinishWriting?(throwableResult)
    }
    
    static func writeImageToDocuments(_ image:UIImage,
                                      fileName filename:String,
                                      onFinishWriting : ((ThrowableResult) -> Void)? = nil){
        var throwableResult = ThrowableResult()
        
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            throwableResult.value = "Unable to get UIImage from image"
            throwableResult.finishedWithoutError = false
            onFinishWriting?(throwableResult)
            return
        }
        guard let fileNameUrl = getFileNameUrl(filename) else {
            throwableResult.value = "Unable to get directorypath as NSURL"
            throwableResult.finishedWithoutError = false
            onFinishWriting?(throwableResult)
            return
        }
        do {
            try data.write(to: fileNameUrl)
            throwableResult.value = "Successfully wrote image to path \(fileNameUrl)"
            throwableResult.finishedWithoutError = true
        } catch {
            throwableResult.value = error.localizedDescription
            throwableResult.finishedWithoutError = false
        }
        
        onFinishWriting?(throwableResult)
    }
    
    static func getSavedImage(_ fileName: String,
                              onFinishWriting : ((ThrowableResult) -> Void)? = nil){
        var throwableResult = ThrowableResult()
        throwableResult.finishedWithoutError = true
        guard let filePath = getAbsoluteFileNamePath(fileName) else{
            throwableResult.value = "Unable to getAbsoluteFileNameUrlPath"
            throwableResult.finishedWithoutError = false
            onFinishWriting?(throwableResult)
            return
        }
        throwableResult.value = UIImage(contentsOfFile:filePath)
        onFinishWriting?(throwableResult)
    }
    /*static func removeFilesFromDocumentsWithExt(_ ext:ImageExt,
                                                      onFinishWriting : @escaping ((ThrowableResult) -> Void)){
        guard let documentsUrl =  getDocumentsUrl() else { return false }

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            //removeItem(atPath: "\(folderPath)/\(path)")
            for fileURL in fileURLs where fileURL.pathComponent == ext.rawValue {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            print(error)
            
        }
    }*/
    
}
