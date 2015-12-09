module SequenceServer
  # Module to contain methods for dealing with taxonomic hierarchy.
  class Hierarchy
  
  	def initialize (root = 'Lepidoptera')
    	@root = root
    end
    
  	def parents
      par = {
        'Agraulis' => 'Butterflies',
  	    'Bicyclus' => 'Butterflies',
  	    'Bombyx' => 'Moths',
  	    'Chilo' => 'Moths',
  	    'Danaus' => 'Butterflies',
  	    'Eueides' => 'Butterflies',
  	    'Heliconius' => 'Butterflies',
  	    'Laparus' => 'Butterflies',
  	    'Lerema' => 'Butterflies',
  	    'Manduca' => 'Moths',
  	    'Melitaea' => 'Butterflies',
  	    'Neruda' => 'Butterflies',
  	    'Papilio' => 'Butterflies',
  	    'Pieris' => 'Butterflies',
  	    'Plodia' => 'Moths',
  	    'Plutella' => 'Moths'
  	  }
  	  par.default = @root
  	  return par
    end
    
    def nesting(name)
      arr = [name]
      until name == @root
        name = parents[name]
        arr.unshift name
      end
      return arr
    end
    
    def nested_list(databases,suffix = '')
      hash = {}
      databases.each do |database|
        title = database.title or database.name
        next unless title.split.last.match(suffix)
        title = title.sub ' - '+suffix, ''
        name = title.split.first.capitalize
        levels = nesting(name)
        parent = 'root'
        levels.each do |level|
          hash[parent] ||= {}
          if level == name
            hash[parent][title] ||= {}
            hash[parent][title]['db'] = database.id
            hash[parent][title]['type'] = database.type
          else
            hash[parent][level] ||= {}
            hash[parent][level]['internal'] = 1;
          end
          parent = level
        end
      end
      return hash
    end

    def ul(databases,suffix = '')
      hash = nested_list(databases,suffix)
      html = enlist(hash,'root')
      return html
    end

    def enlist(hash,parent)
      html = '<ul>'
      hash[parent].each do |key,value|
        html += '<li'
        html += ' class="open"' if parent == 'root'
        if value['internal']
          html += '>'+key
        else
          html += ' name="databases[]" value="'+value['db']+'" data-type="'+value['type']+'">'+key
        end
        if value['internal']
          html += enlist(hash,key)
        end
        html += '</li>'
      end
      html += '</ul>'
      return html
    end

  end
end

