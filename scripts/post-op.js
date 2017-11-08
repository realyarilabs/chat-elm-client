const replace = require('replace-in-file');
var Sync = require('sync');
var exechooks = function() {
  var folder = 'src/static/example/yarilabs-stuff/';
  var file = 'yarilabs_chat_embed.js';
  console.log('Running post-hooks\n');
  console.log('Replace iframe src file:\n');
  const options = {
    files: folder + file,
    from: /iframe.src = "widget.html";/g,
    to: 'iframe.src = "index.html";',
  };
  replace(options)
    .then(changes => {
      console.log('Modified files:\n', changes.join(', '));
      console.log('Replace changes: DONE!\n');
    })
    .catch(error => {
      console.error('Error occurred:', error);
    });
}.async();

Sync(function() {
  exechooks.sync(null);
})
