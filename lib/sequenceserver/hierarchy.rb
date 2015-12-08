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
    
    def nested_list(databases)
      hash = {}
      databases.each do |database|
      	title = database.title or database.name
        name = title.split.first.capitalize
        type = database.type
        levels = nesting(name)
        parent = 'root'
        levels.each do |level|
          hash[parent] ||= []
          if level == name
            db = database.id
          else
            db = false
          end
          hash[parent].push {:name => level, :db => db, :type => type}
          parent = level
        end
      end
      return hash
    end
    
    #def ul(databases)
    #  hash = nested_list(databases)
    #  hash['root'].each do |level|
    #    puts key
    #    value.each do |k,v|
    #      puts k
    #      puts v
    #    end
    #  end
    #  return hash
    #end
    
  end
end

