import js.Browser.document;
import js.Browser.window;
import js.html.ButtonElement;
import js.html.Element;

class Renderer {
    static function main():Void {
        window.addEventListener("DOMContentLoaded", _ -> initialize());
    }

    private static function initialize():Void {
        var status = requiredElement("status");
        var button:ButtonElement = cast requiredElement("action");
        var count = 0;

        requiredElement("year").textContent = Std.string(Date.now().getFullYear());
        button.addEventListener("click", _ -> {
            count++;
            status.textContent = count == 1
                ? "The renderer is responding."
                : 'The renderer has responded $count times.';
            button.textContent = "Run again";
        });
    }

    private static function requiredElement(id:String):Element {
        var element = document.getElementById(id);
        if (element == null) {
            throw 'Missing required element #$id';
        }
        return element;
    }
}

