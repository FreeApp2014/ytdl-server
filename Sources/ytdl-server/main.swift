import Vapor
let app = Application();

let downloadCache: String = ".";

app.get("hello", use: {req in
    return "Hello world";
});

app.get("getQualities") {req -> String in
    guard let link: String = req.query["link"] else {
        return "Please provide Link"
    }
    let a = retrieveQualityList(url: link);
    let b: String;
    switch(a){
    case .success(let data):
        b = data.joined(separator: "\\");
    case .failure(let error):
        b = "error \(error)";
    }
    return b;
}

app.get("download") { req -> Response in
    guard let link: String = req.query["link"] else {
        return Response(body: .init(string: "Please provide Link"));
    }
    guard let fmt: String = req.query["format"] else {
        return Response(body: .init(string: "Please provide Format"));
    }
    if (!supportedQualities.contains(fmt)){
        return Response(body: .init(string: "Format not supported"));
    }
    let a = downloadVideo(link: link, fmtStr: youtubeQualityLookupTable[fmt]!, rId: String.generateUID(5));
    switch (a){
    case .failure(let error):
        return Response(body: .init(string: "error: \(error)"));
    case .success(let id):
        var headers = HTTPHeaders();
        headers.add(name: .contentType, value: "video/mp4");
        headers.add(name: "Content-Disposition", value: "filename=\"\(req.headers["fileName"][0]).mp4\"")
        let s = downloadCache + "/\(id).mp4"
        let data: Data = try! FileHandle(forReadingAtPath: s)!.readToEnd()!;
        try! FileManager.default.removeItem(atPath: s);
        return Response(headers: headers, body: .init(data: data))
    }
}
app.middleware.use(FileMiddleware(publicDirectory: downloadCache));

try! app.run()