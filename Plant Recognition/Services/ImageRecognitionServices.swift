//
//  ImageRecognitionServices.swift
//  Plant Recognition
//
//  Created by Mohammad Hamudeh on 23/04/2022.
//

import Foundation
import Alamofire
class ImageRecognitionServices{
    static let instance = ImageRecognitionServices()
    func getImageRecognitionResults(image:URL, completionHandler:@escaping (Result<ImageResults,Error>) -> ()){
        AF.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(image, withName: "images")
        }, to:"https://my-api.plantnet.org/v2/identify/all?api-key=2b10Od0XHQKbw4mWU9fLsgGtNe", method: .post).responseData { (result) in
            switch result.result{
            case .success(let value ):
                let jsonDecoder = JSONDecoder()
                do{
                   let imageResult = try jsonDecoder.decode(ImageResults.self, from: value)
                    completionHandler(.success(imageResult))
                }catch (let error){
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    func getImageRecognitionResults(image:Data, completionHandler:@escaping (Result<ImageResults,Error>) -> ()){
        AF.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(image, withName: "images")
        }, to:"https://my-api.plantnet.org/v2/identify/all?api-key=2b10Od0XHQKbw4mWU9fLsgGtNe", method: .post).responseData { (result) in
            switch result.result{
            case .success(let value ):
                let jsonDecoder = JSONDecoder()
                do{
                   let imageResult = try jsonDecoder.decode(ImageResults.self, from: value)
                    completionHandler(.success(imageResult))
                }catch (let error){
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

