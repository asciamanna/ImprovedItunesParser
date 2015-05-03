lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

GEM::Specification.new do |spec|
	spec.name = "itunesparser"
	spec.version = '0.1'
	spec.authors = ['Anthony Sciamanna']
	spec.email = ['asciamanna@gmail.com']
	spec.summary = %q{iTunes Library Parser}
	spec.description = %q{iTunes Library parser written in Ruby}
	spec.homepage = 'http://www.github.com/asciamanna/ImprovedItunesParser'
	spec.license = 'MIT'
	spec.files = `git ls-files`.split($/) 
	spec.test_files = `git ls-files -- test`.split($/)
end

							 
