import hxp.Script;
import sys.FileSystem;
import sys.io.File;

class Build extends Script {
    public static function main():Void {
        new Build();
    }

    public function new() {
        super();

        // HXP executes scripts from their containing directory. Restore the
        // project directory so every build path stays relative to the root.
        Sys.setCwd(workingDirectory);

        ensureCleanOutput("dist");
        compile("build-main.hxml");
        compile("build-renderer.hxml");
        copyDirectory("public", "dist");

        Sys.println("Built dist/main.js, dist/renderer.js, and static assets.");
    }

    private function compile(config:String):Void {
        var result = Sys.command("haxe", [config]);
        if (result != 0) {
            Sys.exit(result);
        }
    }

    private function ensureCleanOutput(path:String):Void {
        if (FileSystem.exists(path)) {
            deleteDirectory(path);
        }
        FileSystem.createDirectory(path);
    }

    private function deleteDirectory(path:String):Void {
        for (name in FileSystem.readDirectory(path)) {
            var child = '$path/$name';
            if (FileSystem.isDirectory(child)) {
                deleteDirectory(child);
            } else {
                FileSystem.deleteFile(child);
            }
        }
        FileSystem.deleteDirectory(path);
    }

    private function copyDirectory(from:String, to:String):Void {
        for (name in FileSystem.readDirectory(from)) {
            var source = '$from/$name';
            var destination = '$to/$name';
            if (FileSystem.isDirectory(source)) {
                FileSystem.createDirectory(destination);
                copyDirectory(source, destination);
            } else {
                File.copy(source, destination);
            }
        }
    }
}
