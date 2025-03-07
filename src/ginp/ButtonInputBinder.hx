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
    var input:GameButtonsListener<TButtons>;
    var dispatcherAlias:String;

    public function new(tbuttonAlias:String, input:GameButtonsListener<TButtons>) {
        this.input = input;
        dispatcherAlias = "GameButtonDispatcher_" + tbuttonAlias;
    }

    public function bind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setListener(input);
    }

    public function unbind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setListener(null);
    }
    
    public static macro function addDispatcher<T:Axis<T>>(basis:ExprOf<T>, e:ExprOf<Entity>, dispatcher:ExprOf<GameButtonsDispatcher<T>>) {
        var basisName = @:privateAccess MacroGenericAliasConverter.checkType(basis);
        var exprs = [];
        exprs.push(
            macro $e.addComponentByName("GameButtonDispatcher_" + $v{basisName}, $dispatcher)
        );
        exprs.push(
            macro new ec.CtxWatcher.CtxWatcherBase("ButtonInputBinder_" + $v{basisName}, $e)
        );
        return macro $b{exprs};
    }
}
#end