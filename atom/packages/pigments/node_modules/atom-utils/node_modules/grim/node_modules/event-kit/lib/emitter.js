(function() {
  var Disposable, Emitter;

  Disposable = require('./disposable');

  module.exports = Emitter = (function() {
    Emitter.exceptionHandlers = [];

    Emitter.onEventHandlerException = function(exceptionHandler) {
      if (this.exceptionHandlers.length === 0) {
        this.dispatch = this.exceptionHandlingDispatch;
      }
      this.exceptionHandlers.push(exceptionHandler);
      return new Disposable((function(_this) {
        return function() {
          _this.exceptionHandlers.splice(_this.exceptionHandlers.indexOf(exceptionHandler), 1);
          if (_this.exceptionHandlers.length === 0) {
            return _this.dispatch = _this.simpleDispatch;
          }
        };
      })(this));
    };

    Emitter.simpleDispatch = function(handler, value) {
      return handler(value);
    };

    Emitter.exceptionHandlingDispatch = function(handler, value) {
      var exception, exceptionHandler, _i, _len, _ref, _results;
      try {
        return handler(value);
      } catch (_error) {
        exception = _error;
        _ref = this.exceptionHandlers;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          exceptionHandler = _ref[_i];
          _results.push(exceptionHandler(exception));
        }
        return _results;
      }
    };

    Emitter.dispatch = Emitter.simpleDispatch;

    Emitter.prototype.disposed = false;


    /*
    Section: Construction and Destruction
     */

    function Emitter() {
      this.clear();
    }

    Emitter.prototype.clear = function() {
      return this.handlersByEventName = {};
    };

    Emitter.prototype.dispose = function() {
      this.handlersByEventName = null;
      return this.disposed = true;
    };


    /*
    Section: Event Subscription
     */

    Emitter.prototype.on = function(eventName, handler, unshift) {
      var currentHandlers;
      if (unshift == null) {
        unshift = false;
      }
      if (this.disposed) {
        throw new Error("Emitter has been disposed");
      }
      if (typeof handler !== 'function') {
        throw new Error("Handler must be a function");
      }
      if (currentHandlers = this.handlersByEventName[eventName]) {
        if (unshift) {
          this.handlersByEventName[eventName] = [handler].concat(currentHandlers);
        } else {
          this.handlersByEventName[eventName] = currentHandlers.concat(handler);
        }
      } else {
        this.handlersByEventName[eventName] = [handler];
      }
      return new Disposable(this.off.bind(this, eventName, handler));
    };

    Emitter.prototype.preempt = function(eventName, handler) {
      return this.on(eventName, handler, true);
    };

    Emitter.prototype.off = function(eventName, handlerToRemove) {
      var handler, newHandlers, oldHandlers, _i, _len;
      if (this.disposed) {
        return;
      }
      if (oldHandlers = this.handlersByEventName[eventName]) {
        newHandlers = [];
        for (_i = 0, _len = oldHandlers.length; _i < _len; _i++) {
          handler = oldHandlers[_i];
          if (handler !== handlerToRemove) {
            newHandlers.push(handler);
          }
        }
        this.handlersByEventName[eventName] = newHandlers;
      }
    };


    /*
    Section: Event Emission
     */

    Emitter.prototype.emit = function(eventName, value) {
      var handler, handlers, _i, _len, _ref;
      if (handlers = (_ref = this.handlersByEventName) != null ? _ref[eventName] : void 0) {
        for (_i = 0, _len = handlers.length; _i < _len; _i++) {
          handler = handlers[_i];
          this.constructor.dispatch(handler, value);
        }
      }
    };

    return Emitter;

  })();

}).call(this);
