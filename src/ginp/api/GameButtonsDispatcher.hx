package ginp.api;

interface GameButtonsDispatcher<T:Axis<T>>
//  #if slec extends ec.CtxWatcher.CtxBinder #end 
{
    function addListener(l:GameButtonsListener<T>):Void;
    function removeListener(l:GameButtonsListener<T>):Void;
}
