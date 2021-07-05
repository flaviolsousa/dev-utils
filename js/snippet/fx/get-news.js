/*

https://www.dailyfx.com/economic-calendar

$.get('https://raw.githubusercontent.com/flaviolsousa/dev-utils/master/js/snippet/fx/get-news.js?_=' + Date.now(), d=>eval(d));

*/

/*jshint esversion: 6 */
function copy(text) {
  var input = document.createElement("input");
  input.setAttribute("value", text);
  document.body.appendChild(input);
  input.select();
  var result = document.execCommand("copy");
  document.body.removeChild(input);
  return result;
}

function processNews(options) {
  const levels = { H: 3, M: 2, L: 1 };
  let time = options.jNews.find("td")[0].innerHTML;
  if (time.length == 0) return;
  time = options.dateTable.toISOString().substring(0, 11) + time + ":00";
  const item = {
    time: time,
    category: options.jNews.attr("data-category").toUpperCase(),
    level:
      levels[$(options.jNews.find("td")[4]).find(".label-sm")[0].innerHTML] ||
      0,
    description: $(options.jNews.find("td")[3])
      .html()
      .replace(/.*>/, "")
      .trim()
  };
  options.result.push(item);
}

function createNews(options) {
  let jTable = options.jTable;
  let date = new Date(
    jTable
      .find(".eco-table-date")
      .html()
      .trim()
  );
  options.dateTable = date;
  jTable.find("tr[data-category]").each((i, v) => {
    options.iNews = i;
    options.jNews = $(v);
    processNews(options);
  });
}

function processDailyFx() {
  let jDates = $(".dfx-calendar-table[id^=daily-cal]");
  options = {
    result: []
  };
  jDates.each((i, v) => {
    options.iTable = i;
    options.jTable = $(v);
    createNews(options);
  });
  let sResult = JSON.stringify(options.result);
  console.info(sResult);
  copy(sResult);
  console.info("### copied to clipboard ###");
  return options.result;
}
var options = {};
processDailyFx();
