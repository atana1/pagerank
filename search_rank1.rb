#!/usr/bin/env ruby

class Page
  @@count = 0
  attr_reader :id
  attr_accessor :keywords

  def initialize()
    @id = @@count + 1
    @keywords = Hash.new
    @@count += 1
  end
end


class Query
  @@count = 0
  attr_reader :id
  attr_accessor :keywords

  def initialize()
    @id = @@count + 1
    @keywords = Hash.new
    @@count += 1
  end
end


class PageStrength
  attr_reader :pageid
  attr_accessor :strength
  def initialize(id, strength)
    @pageid = id
    @strength = strength
  end
end



class SearchRanking
  # pages, to contain all page object
  # queries, to contain all query objects
  @@pages = []
  @@queries = []

  def parse
    # parses the standard input (file in this case)
    # and builds array of Page and Query objects
    begin
      file = File.new("input", "r")
      while (line = file.gets)
        if line.start_with?('P')
          keywords = line.split()
          # create Page object
          page = Page.new()
          keywords.delete(keywords[0])
          keyword_index_pair = keywords.zip((0...8))
          keyword_index_pair.each do |keyword, index|
            page.keywords[keyword.downcase] = 8-index
          end
          @@pages.push(page)
        elsif line.start_with?('Q')
          keywords = line.split()
          # create Query object
          query = Query.new()
          keywords.delete(keywords[0])
          keyword_index_pair = keywords.zip((0...8))
          keyword_index_pair.each do |keyword, index|
            query.keywords[keyword.downcase] = 8 - index
          end
          @@queries.push(query)
        end
      end
      file.close
    rescue => err
      puts "Exception: #{err}"
      err
    end
  end

  def rank_pages
  	# calculates the strength of each page against each query and
  	# displays the ranking of pages based on decreasing order of strength
  	@@queries.each do |query|
  		page_strengths = []
  		@@pages.each do |page|
  			strength = 0
  			query.keywords.each_key do |qkey|
  				if page.keywords.has_key?(qkey)
  					strength = strength + query.keywords[qkey]*page.keywords[qkey]
  				end
  			end
  			pstrength = PageStrength.new(page.id, strength)
  			page_strengths.push(pstrength)
  		end
  		# ranking pages: sorting in descending order based on strength value.
      # a stable nlogn sorting algorithm can be used instead of bubble sort
      # to reduce time complexity of the problem.
      bubble_sort(page_strengths)
      
      # display topfive(or fewer) pages for a particular query
  		print "Q#{query.id}: "

      page_strengths[0, 5].each do |ps|
        if ps.strength != 0
          print "P#{ps.pageid} "
        end
      end
      puts

  	end
  end
end


def bubble_sort(array)
  # it is a stable sort and sorts an array descending order
  n = array.length
  loop do
    swapped = false
 
    (n-1).times do |i|
      if array[i].strength < array[i+1].strength
        array[i], array[i+1] = array[i+1], array[i]
        swapped = true
      end
    end
 
    break if not swapped
  end
 
  array
end


if __FILE__ == $0
  sr = SearchRanking.new()
  sr.parse()
  sr.rank_pages()
end