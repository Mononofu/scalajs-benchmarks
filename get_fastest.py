import csv
import collections
import itertools
import numpy

groups = collections.defaultdict(list)


def group_key(row):
  """Group by benchmark and language."""
  return '%s__%s' % (row[0], row[1])


def median(rows):
  return numpy.median([float(r[5]) for r in rows])

header = None
with open('bencher/summary/all_measurements.csv') as f:
  r = csv.reader(f, delimiter=',')
  header = r.next()
  for row in r:
    groups[group_key(row)].append(row)

rows = []
for group in groups.itervalues():
  results_by_id = {}
  for id, results in itertools.groupby(group, lambda r: r[2]):
    rs = list(results)
    results_by_id[id] = (median(rs), rs)
  rows += min(results_by_id.itervalues(), key=lambda p: p[0])[1]


rows = sorted(rows)

with open('summary.csv', 'w') as f:
  writer = csv.writer(f, delimiter=',')
  writer.writerow(header)
  for r in rows:
    writer.writerow(r)
