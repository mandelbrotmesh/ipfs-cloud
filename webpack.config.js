var path = require('path')
var elmsource = __dirname + '/src/elm/'

module.exports = {
    entry: './src/js/app.js',
    output: {
        path: path.join(__dirname, 'build/'),
        filename: '[name].js'
    },

    module: {
        rules: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/,/node_modules/],
                loader: 'elm-webpack-loader?verbose=true&warn=true&cwd=' + elmsource,
            },
            {
                test:    /\.html$/,
                exclude: /node_modules/,
                loader:  'file-loader?name=[name].[ext]',
            },
      	    {
      		test: /web-components\//,
      		loader: 'web-components-loader',
      	    },
	    {
		test: /css\//,
		loader: 'webpack-css-loaders',
	    }

        ]
    }
}
