(function(e){
    // matches polyfill
    e.matches || (e.matches=e.matchesSelector||function(selector){
            var matches = document.querySelectorAll(selector), th = this;
            return Array.prototype.some.call(matches, function(e){
                return e === th;
            });
        });

})(Element.prototype);
(function(ELEMENT) {
    // closest polyfill
    ELEMENT.matches = ELEMENT.matches || ELEMENT.mozMatchesSelector || ELEMENT.msMatchesSelector || ELEMENT.oMatchesSelector || ELEMENT.webkitMatchesSelector;
    ELEMENT.closest = ELEMENT.closest || function closest(selector) {
            if (!this) return null;
            if (this.matches(selector)) return this;
            if (!this.parentElement) {return null}
            else return this.parentElement.closest(selector)
        };
}(Element.prototype));