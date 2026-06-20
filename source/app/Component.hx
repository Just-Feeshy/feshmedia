package app;

import js.Browser.document;
import js.html.Element;

/**
 * Minimal stateful view base. A component owns a persistent `root` element;
 * `build()` returns its current contents and `refresh()` re-renders them in
 * place. State lives in subclass fields — mutate, then call `refresh()`.
 */
class Component {
    public final root:Element;

    public function new(?tag:String, ?cls:String) {
        root = document.createElement(tag != null ? tag : "div");
        if (cls != null) root.className = cls;
    }

    /** Append `root` to a parent and render for the first time. */
    public function mount(parent:Element):Element {
        parent.appendChild(root);
        refresh();
        return root;
    }

    /** Re-render the component's contents from current state. */
    public function refresh():Void {
        Dom.fill(root, [build()]);
    }

    /** Override to return the component's contents. */
    function build():Element {
        return document.createElement("div");
    }
}
