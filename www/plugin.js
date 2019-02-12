var DateSettings = (function(){
    DateSettings = {
        checkAutomaticTime: function(successFn, errorFn){
            cordova.exec(successFn,errorFn,'dateSettings','checkAutomaticTime',[]);
        },
        open: function (successFn, errorFn) {
        	cordova.exec(successFn,errorFn,'dateSettings','open',[]);
        }
    };
    return DateSettings;
});
module.exports = new DateSettings();