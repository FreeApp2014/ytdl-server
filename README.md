# ytdl-server

A simple YouTube downloading server based on [youtube-dl](https://github.com/ytdl-org/youtube-dl). <br />
Written in Swift using [Vapor 4](https://github.com/vapor/vapor).

## Requirements
Requires `youtube-dl` command-line tool to be [installed](https://github.com/ytdl-org/youtube-dl#installation) and available in `$PATH` and Swift 5.3 or later.

## Installation 
Clone this repository. Run `swift package resolve` to download all dependencies. Build using `swift build` and run using `swift run`<br />
By default the Vapor server starts on 127.0.0.1:8080. You should use a reverse proxy (like Apache or nginx) to expose the service outside localhost. Additionally, you may run the server using <br /> `swift run ytdl-server serve  --hostname 0.0.0.0 --port <port-number>` <br />  for debug purposes.
### Configuration
In `main.swift` put the file download path you like into `downloadCache` (by default the files are downloaded to the build folder with the binary files)

## Usage
This can be used with [iOS Shortcut](https://www.icloud.com/shortcuts/32c181f481e149a7934b3b3f94216d32) or directly: 
* GET `/getQualities`:
* * `link` - link to youtube video
* * Returns: video title and possible `fmtString` values separated by `\`
* GET `/download`:
* * `link` - link to youtube video
* * `format` - fmtString value received from previous endpoint
* * Header `fileName` will force file name to be what specified (used in the shortcut), by default `download.mp4`
* * Returns: mp4 file with AVC video and AAC audio (for compatibility with iOS devices)
