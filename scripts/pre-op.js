const replace = require('replace-in-file');
var Sync = require('sync');
const cpy = require('cpy');
var exechooks = function() {
  var folder = 'src/static/example/yarilabs-stuff/';
  var file = 'yarilabs_chat_embed.js';
  var file_tmp = 'tmp-yarilabs_chat_embed.js';
  console.log('Running pre-hooks\n');
  console.log('Copy file:\n');
  cpy(folder + file, folder, {
    rename: basename => `tmp-${basename}`
  });
  console.log('Copy file: DONE!\n');
  console.log('Replace iframe url:\n');
  const options = {
    files: folder + file,
    from: /iframe.src = "index.html";/g,
    to: 'iframe.src = "widget.html";',
  };
  replace(options)
    .then(changes => {
      console.log('Modified files:\n', changes.join(', '));
      console.log('Replace:DONE!\n');
    })
    .catch(error => {
      console.error('Error occurred:', error);
    });
}.async()

Sync(function() {
  exechooks.sync(null);
})
