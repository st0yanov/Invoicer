require_relative 'app/app'
run Invoicer

map('/auth') { run AuthenticationController }
map('/partners') { run PartnersController }
map('/invoices') { run InvoicesController }
