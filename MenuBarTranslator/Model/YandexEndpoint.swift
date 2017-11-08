//
//  YandexEndpoint.swift
//  MenuBarTranslator
//
//  Created by Artem Bobrov on 07.08.17.
//  Copyright © 2017 Artem Bobrov. All rights reserved.
//

import Foundation

enum Yandex {
    case translate(text: String, lang: String)
    
    case languages
    
    case detectLanguage(text: String)

	case pronounce(text: String, lang: String)

    var request: URLRequest {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
    
    private var baseUrl : String {
		switch self {
			case .pronounce:
				return "https://tts.voicetech.yandex.net"
			default:
				return "https://translate.yandex.net/api/v1.5/tr.json"

		}
    }
    
    private var translateKeyAPI : String {
        return "trnsl.1.1.20170804T195228Z.43cbafd05327100f.0b80728653b33567b49b4c25d39b50a6f4b18127"
    }

	private var speechKeyAPI:  String {
		return "f0b4e5d5-4199-42a3-acdb-72f40c60017e"
	}
    
    private var path : String {
        switch self {
            case .translate:
                return "/translate"
            case .languages:
                return "/getLangs"
            case .detectLanguage:
                return "/detect"
			case .pronounce:
				return "/generate"
        }
    }
    
    private struct ParameterKeys {
        static let key = "key"
        static let text = "text"
        static let lang = "lang"
		static let speaker = "speaker"
		static let format = "format"
    }
    
    private var parameters: [String : Any] {
        switch self {
            case .translate(let text, let lang):
                let parameters: [String : Any] = [
                    ParameterKeys.key: translateKeyAPI,
                    ParameterKeys.text: text,
                    ParameterKeys.lang: lang
                ]
            
                return parameters
            case .languages:
                let parameters: [String: Any] = [
                    ParameterKeys.key: translateKeyAPI
                ]
                return parameters
            case .detectLanguage(let text):
                let parameters: [String : Any] = [
                    ParameterKeys.key: translateKeyAPI,
                    ParameterKeys.text: text
                ]
                return parameters
			case .pronounce(let text, let lang):
				let parameters: [String : Any] = [
					ParameterKeys.key: speechKeyAPI,
					ParameterKeys.text: text,
					ParameterKeys.format: "mp3",
					ParameterKeys.lang: "\(lang)-\(lang.uppercased())",
					ParameterKeys.speaker: "jane"
				]
				return parameters
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
		parameters.forEach({
			let queryItem = URLQueryItem(name: $0, value: "\($1)")
			components.append(queryItem)
		})
        return components
    }
}
