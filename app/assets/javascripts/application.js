// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery-ui
//= require jquery.turbolinks
//= require jquery.readyselector
//= require jquery.simplePagination
//= require handlebars
//= require bootbox.min
//= require numeral.min
//= require picker
//= require picker.date
//= require legacy
//= require parsley
//= require parsley.remote
//= require formValidation/formValidation
//= require formValidation/en_US
//= require formValidation/bootstrap
//= require jquery.sticky
//= require moment
//=require underscore
//=require clndr-rails
//= require_tree .

$(document).ready(function(){
	$('a[href^="#"]').on('click',function (e) {
	    e.preventDefault();

	    var target = this.hash;
	    var $target = $(target);

	    $('html, body').stop().animate({
	        'scrollTop': $target.offset().top
	    }, 900, 'swing', function () {
	        window.location.hash = target;
	    });
	});
});
