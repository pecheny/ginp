package ginp.api;

interface GameButtonsDispatcher<T:Axis<T>>
//  #if slec extends ec.CtxWatcher.CtxBinder #end 
{
    function setListener(l:GameButtonsListener<T>):Void;
}
