package ginp.api;

interface KbdDispatcher #if slec extends ec.CtxWatcher.CtxBinder #end {
    function addListener(l:KbdListener):Void;
    function removeListener(l:KbdListener):Void;
}
