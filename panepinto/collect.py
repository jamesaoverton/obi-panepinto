#!/usr/bin/env python3

import argparse, csv, re

def main():
  # Parse arguments
  parser = argparse.ArgumentParser(
      description='Collect labels and terms from a HOWL file')
  parser.add_argument('howl',
      type=argparse.FileType('r'),
      help='a HOWL file')
  parser.add_argument('table',
      type=argparse.FileType('r'),
      help='a TSV file')
  args = parser.parse_args()

  labels = set()
  terms = set()
  last = None
  for line in args.howl:
    if line.strip() != '' and not line.startswith('#'):
      if line.startswith('type:> '):
        terms.add(line[7:].strip())
      if last and last.strip() == '':
        labels.add(line.strip())
    last = line

  for label in sorted(labels):
    print('<' + re.sub(r'\W+', '-', label) + '>')
    print('label: ' + label)
  print()

  rows = csv.reader(args.table, delimiter='\t')
  headers = next(rows)
  for row in rows:
    if len(row) < 1:
      continue
    label = row[1].replace('@en', '')
    if label not in terms:
      continue
    for i in range(0, min(len(headers), len(row))):
      if row[i].strip() == '':
        continue
      if headers[i] == 'SUBJECT':
        print(row[i])
      elif '%' in headers[i]:
        print(headers[i].replace('%', row[i]))
      else:
        print(headers[i] +' '+ row[i])
    print()

# Run the main() function.
if __name__ == "__main__":
  main()
