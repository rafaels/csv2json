require 'fastercsv'
require 'json'
require 'csv2json-version.rb'

module CSV2JSON

    # convert an input string value to integer or float if applicable
    def convert(val)
        return Integer(val) if val.to_i.to_s == val
        Float(val) rescue val
    end

    # input and output are file objects, you can use StringIO if you want to work in memory
    def parse(input, output, headers=nil, options={})
        result = Array.new

        FasterCSV.new(input, options).each do |row|
            # treat first row as headers if the caller didn't provide them
            unless headers 
                headers = row
                next
            end
            
            # build JSON snippet and append it to the result
            snippet = Hash.new
            headers.each_index { |i| snippet[headers[i]] = self.convert(row[i]) }
            result << snippet
        end
        
        output << JSON.pretty_generate(result)
    end
    
    module_function :parse
    module_function :convert
    
end
