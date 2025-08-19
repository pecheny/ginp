package ginp;

#if slec
import ec.CtxWatcher.CtxBinder;
import ec.Entity;
import ginp.GameButtonsImpl;
import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;
#if macro
import haxe.macro.Expr.ExprOf;
import utils.MacroGenericAliasConverter;
#end

class ButtonInputBinder<TButtons:Axis<TButtons>> implements CtxBinder {
    var dispatcher:GameButtonsDispatcher<TButtons>;
    var listenerAlias:String;

    public function new(tbuttonAlias:String, input:GameButtonsDispatcher<TButtons>) {
        this.dispatcher = input;
        listenerAlias = "GameButtonsListener_" + tbuttonAlias;
    }

    public function bind(e:Entity) {
        var listener:GameButtonsListener<TButtons> = e.getComponentByName(listenerAlias);
        dispatcher.addListener(listener);
    }

    public function unbind(e:Entity) {
        var listener:GameButtonsListener<TButtons> = e.getComponentByName(listenerAlias);
        dispatcher.removeListener(listener);
    }
    
    public static macro function addListener<T:Axis<T>>(basis:ExprOf<T>, e:ExprOf<Entity>, listener:ExprOf<GameButtonsListener<T>>) {
        var basisName = @:privateAccess MacroGenericAliasConverter.checkType(basis);
        var exprs = [];
        exprs.push(
            macro $e.addComponentByName("GameButtonsListener_" + $v{basisName}, $listener)
        );
        exprs.push(
            macro new ec.CtxWatcher.CtxWatcherBase("ButtonOutputBinder_" + $v{basisName}, $e)
        );
        return macro $b{exprs};
    }
}
#end