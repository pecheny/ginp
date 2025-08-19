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

class ButtonOutputBinder<TButtons:Axis<TButtons>> implements CtxBinder {
    public static inline var  DISPATCHER_PREFIX = "GameButtonDispatcher_";
    var input:GameButtonsListener<TButtons>;
    var dispatcherAlias:String;

    public function new(tbuttonAlias:String, input:GameButtonsListener<TButtons>) {
        this.input = input;
        dispatcherAlias = DISPATCHER_PREFIX + tbuttonAlias;
    }

    public function bind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.addListener(input);
    }

    public function unbind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.removeListener(input);
    }
    
    public static macro function addDispatcher<T:Axis<T>>(basis:ExprOf<T>, e:ExprOf<Entity>, dispatcher:ExprOf<GameButtonsDispatcher<T>>) {
        var basisName = @:privateAccess MacroGenericAliasConverter.checkType(basis);
        // trace(basisName, Context.getLocalClass());
        // todo try to apply typeparams of localClass to basis.
        // for now using generic basis in place lead to _T aliases instead of eal type names.
        var exprs = [];
        exprs.push(
            macro $e.addComponentByName(ButtonOutputBinder.DISPATCHER_PREFIX  + $v{basisName}, $dispatcher)
        );
        exprs.push(
            macro new ec.CtxWatcher.CtxWatcherBase("ButtonOutputBinder_" + $v{basisName}, $e)
        );
        return macro $b{exprs};
    }
}
#end