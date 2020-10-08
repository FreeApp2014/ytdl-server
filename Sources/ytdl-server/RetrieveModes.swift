//
// Created by freeapp on 07.10.2020.
//

import Foundation
import ShellOut

let supportedQualities: [String] = ["144p", "240p", "360p", "480p", "480p60", "720p", "dash_720p60", "720p60", "1080p", "1080p60"]

let youtubeQualityLookupTable: [String: String] = [
    "144p": "160+140",
    "240p": "133+140",
    "360p": "18",
    "480p": "135+140",
    "480p60": "333+140",
    "720p": "22",
    "720p60":"298+140",
    "dash_720p60": "302+140",
    "1080p": "137+140",
    "1080p60": "299+140"
];

enum YTError: Error {
    case yDlError(desc: String);
}

func retrieveQualityList(url: String) -> Result<[String], YTError> {
    var output: String, output2: String;
    do {
        output = (try shellOut(to: "youtube-dl -F \(url)"));
        output2 = (try shellOut(to: "youtube-dl -e \(url)"));
    } catch {
        let error = error as! ShellOutError
        return .failure(YTError.yDlError(desc: error.message))
    }
    let split = output.split(separator: "\n");
    var out = [String]();
    out.insert(output2, at: 0);
    for line in split {
        let contents = line.split(separator: " ", omittingEmptySubsequences: true);
        if (!out.contains(String(contents[3])) && supportedQualities.contains(String(contents[3]))) {out.insert(String(contents[3]), at: out.count)} else {
            if (contents[3] == "DASH") {
                switch (contents[0]) {
                case "302":
                    out.insert("dash_720p60", at: out.count);
                case "299":
                    out.insert("1080p60", at: out.count);
                case "133":
                    out.insert("240p", at: out.count);
                default: break;
                }
            }
        }
    }
    return .success(out);
}

