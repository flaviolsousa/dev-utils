/*

USE:

amountExecute=15;$.get( 'https://raw.githubusercontent.com/flaviolsousa/dev-utils/master/js/snippet/fx/dailyfx-calendar-back.js?_=' + Date.now(), d=>eval(d));

*/
/*jshint esversion: 6 */
function checkNext(i) {
  const innerHtml = $(".grid-prev").html();
  if (innerHtml.indexOf("spinner") > 0) {
    setTimeout(() => checkNext(i), 2000);
  } else {
    execute(i + 1);
  }
}

function execute(i) {
  if (i <= amountExecute) {
    $(".grid-prev").click();
    checkNext(i);
  }
}

execute(1);
