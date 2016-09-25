#!/usr/bin/python


class Page(object):
	count = 0

	def __init__(self):
		self.id = Page.count + 1
		self.keywords = {}
		Page.count += 1


class Query(object):
	count = 0

	def __init__(self):
		self.id = Query.count + 1
		self.keywords = {}
		Query.count += 1


class PageStrength(object):
	def __init__(self, id, strength):
		self.pageid = id
		self.strength = strength


class SearchRanking(object):
	'''pages will contains all the page objects.
	   queries will contains all the query objects
	'''
	pages = []
	queries = []

	def parse(self):
		'''parses the standard input (file in this case)
		   and builds list of Page and Query objects
		'''		 
		try:
			f = open('input', 'r')
		except:
			print "input file not found!"
			return
		
		for line in f:
			if line.startswith('P'):
				keywords = line.split()
				# create Page object
				page = Page()
				del keywords[0]
				for i, keyword in zip(range(0, 8), keywords):
					page.keywords[keyword.lower()] = 8-i
				SearchRanking.pages.append(page)
			elif line.startswith('Q'):
				keywords = line.split()
				# create Query object
				query = Query()
				del keywords[0]
				for i, keyword in zip(range(0, 8), keywords):
					query.keywords[keyword.lower()] = 8 - i
				SearchRanking.queries.append(query)
		f.close()

	def rank_pages(self):
		'''calculates the strength of each pages against every query and
		   displays the ranking of pages based on decreasing order of strength.
		'''
		for query in SearchRanking.queries:
			page_strengths = []
			for page in SearchRanking.pages:
				strength = 0
				for qkey in query.keywords:
					if qkey in page.keywords:
						strength = strength + query.keywords[qkey]*page.keywords[qkey]
				pstrength = PageStrength(page.id, strength)
				page_strengths.append(pstrength)

			# ranking pages: sorting in descending order based on strength value.
			page_strengths.sort(reverse=True, key=lambda page_strengths: page_strengths.strength)
			# display topfive(or fewer) pages for a particular query
			print "Q%s: " %(query.id),
			for ps in page_strengths[:5]:
				if ps.strength is not 0:
					print "P%s" %(ps.pageid),
			print


if __name__ == '__main__':
	sr = SearchRanking()
	sr.parse()
	sr.rank_pages()