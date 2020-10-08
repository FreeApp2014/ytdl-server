//
// Created by freeapp on 07.10.2020.
//

import Foundation
import ShellOut

extension String {
    static func generateUID(_ len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
        return String((0..<len).map{ _ in letters.randomElement()! })
    }
}

func downloadVideo(link: String, fmtStr: String, rId: String) -> Result<String, YTError> {
    do {
        try shellOut(to: "youtube-dl -f \(fmtStr)  \(link) -o \(downloadCache)/\(rId).mp4");
    } catch {
        let error = error as! ShellOutError;
        return .failure(.yDlError(desc: error.message));
    }
    return .success(rId);
}