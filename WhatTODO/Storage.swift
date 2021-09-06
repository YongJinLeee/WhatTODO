//  WhatTODO
//
//  Created by LeeYongJin
//

import Foundation

public class Storage {
    
    // business Logic 캡슐화
    private init() { }
    
    // JSON은 [Key : value] 와 같은 dictionary
    // Codable protocol 준수
    enum Directory {
        case documents
        case caches
        
        var url: URL {
            let path: FileManager.SearchPathDirectory
            
            switch self {
            case .documents:
                path = .documentDirectory
            case .caches:
            path = .cachesDirectory
                
            }
            // 사용자 지정 디렉토리로 반환
            return FileManager.default.urls(for: path, in: .userDomainMask).first!
        }
    }
    
    // zediios님의 관련 글 참조
    // https://zeddios.tistory.com/373
    // JSON Encoding method
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        // Test
        // 파일 저장위치 console 확인용
        print("저장된 파일 디렉토리 주소 : \(url)")
        
        let encoder = JSONEncoder()
        // encoding 결과물 출력 포멧
        // .prettyPrinted -> JSON 포맷으로 표기
        // .sortedKey -> Key값기준 오름차순 정렬
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(object)
            // data는 이때 Data 타입으로 캐스팅됨
            // 인코딩을 통해 JSON 파일을 만들고, 해당 url 경로에 이미 파일이 존재하면 해당 파일을 지우고
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) // 검사 후 파일 생성
        } catch let error {
            print("저장에 실패했습니다. error: \(error.localizedDescription)")
        }
    }
    
    // throws -> try에 do-catch 예외처리가 되면 굳이 try 뒤에 ?로 옵셔널하게 사용하지 않아도 된다.
    
    // Decoding JSON
    // Data 타입형태(codable decode 가능한)로 파일 읽음
    // file
    static func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil } // 해당경로에 파일이 있다면 decoding 진행하고 아니면 nil 반환
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil } // type casting (Data)
        
        let decoder = JSONDecoder()
        
        do {
            // decodable protocol을 준수하는 T, T를 변수타입으로 받는 type
            // 파일을 data 로 받음
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("파일 디코딩에 실패했습니다(Failed of decode). error: \(error.localizedDescription)")
            return nil
        }
    }
    // JSON Data파일 삭제
    static func remove(_ fileName: String, from directory: Directory) {
        let url =  directory.url.appendingPathComponent(fileName, isDirectory: false)
        // 오류 발생 가능성 때문에 옵셔널 바인딩
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("파일 삭제에 실패했습니다(Failed of remove). error: \(error.localizedDescription)")
        }
    }
    //  사용후 경로내 디렉토리 초기화
    static func clear(_ directory: Directory) {
        let url = directory.url
        
        do {
            let contnets = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for content in contnets {
                try FileManager.default.removeItem(at: content)
            }
        } catch {
            print("디렉토리 초기화에 실패했습니다(Failed of directory clear). error: \(error.localizedDescription)")
        }
        
    }
    
}
