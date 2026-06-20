import electron.main.App;
import electron.main.BrowserWindow;
import js.Node.__dirname;
import js.Node.process;
import js.node.Path;

class Main {
    private static var mainWindow:BrowserWindow;

    static function main():Void {
        App.whenReady().then(_ -> {
            createWindow();
            return null;
        });

        App.on(window_all_closed, _ -> {
            if (process.platform != "darwin") {
                App.quit();
            }
        });
    }

    private static function createWindow():Void {
        var isSmokeTest = App.commandLine.hasSwitch("smoke-test")
            || process.argv.indexOf("--smoke-test") != -1;
        var rendererLoaded = false;

        mainWindow = new BrowserWindow({
            width: 1040,
            height: 700,
            minWidth: 760,
            minHeight: 520,
            backgroundColor: "#07111f",
            show: false,
            webPreferences: {
                contextIsolation: true,
                nodeIntegration: false,
                sandbox: true
            }
        });

        mainWindow.once("ready-to-show", () -> mainWindow.show());
        mainWindow.on("closed", () -> mainWindow = null);
        mainWindow.loadFile(Path.join(__dirname, "index.html")).then(_ -> {
            rendererLoaded = true;
            if (isSmokeTest) {
                Sys.println("Electron loaded the renderer successfully.");
                App.quit();
            }
            return null;
        });

        if (isSmokeTest) {
            haxe.Timer.delay(() -> {
                if (!rendererLoaded) {
                    Sys.stderr().writeString("Renderer smoke test timed out.\n");
                    App.exit(1);
                }
            }, 5000);
        }
    }
}
