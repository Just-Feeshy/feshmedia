import js.Browser.document;
import js.Browser.window;
import app.App;

/** Renderer entry point — boots the App shell into the #app root. */
class Renderer {
    static function main():Void {
        window.addEventListener("DOMContentLoaded", _ -> {
            var mount = document.getElementById("app");
            if (mount == null) {
                throw "Missing required element #app";
            }
            new App().mount(mount);
        });
    }
}
