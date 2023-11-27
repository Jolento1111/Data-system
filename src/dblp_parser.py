##########################################################
# main reference: https://github.com/26hzhang/DBLPParser #
##########################################################

from lxml import etree
from datetime import datetime
import csv
import codecs
import ujson
import re

# all of the element types in dblp
all_elements = {"article", "inproceedings", "proceedings", "book", "incollection", "phdthesis", "mastersthesis", "www"}
# all of the feature types in dblp
all_features = {"address", "author", "booktitle", "cdrom", "chapter", "cite", "crossref", "editor", "ee", "isbn",
                "journal", "month", "note", "number", "pages", "publisher", "school", "series", "title", "url",
                "volume", "year"}


def log_msg(message):
    """Produce a log with current time"""
    print(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), message)

def context_iter(dblp_path):
    """Create a dblp data iterator of (event, element) pairs for processing"""
    return etree.iterparse(source=dblp_path, dtd_validation=True, load_dtd=True)  # required dtd

def clear_element(element):
    """Free up memory for temporary element tree after processing the element"""
    element.clear()
    while element.getprevious() is not None:
        del element.getparent()[0]

def count_pages(pages):
    cnt = 0
    for part in re.compile(r",").split(pages):
        subparts = re.compile(r"-").split(part)
        if len(subparts) > 2:
            continue
        else:
            try:
                re_digits = re.compile(r"[\d]+")
                subparts = [int(re_digits.findall(sub)[-1]) for sub in subparts]
            except IndexError:
                continue
            cnt += 1 if len(subparts) == 1 else subparts[1] - subparts[0] + 1
    return "" if cnt == 0 else str(cnt)


def extract_feature(elem, features, include_key=False, include_publtype=False):
    """Extract the value of each feature"""
    if include_key:
        attribs = {'key': [elem.attrib['key']], 'mdate':[elem.attrib['mdate']]}        
        if include_publtype: 
            attribs['publtype'] = [elem.attrib['publtype']] if 'publtype' in elem.keys() else []
    else:
        attribs = {}
        
    for feature in features:
        attribs[feature] = []
    for sub in elem:
        if sub.tag not in features:
            continue
        if sub.tag == 'title':
            text = re.sub("<.*?>", "", etree.tostring(sub).decode('utf-8')) if sub.text is None else sub.text
        # elif sub.tag == 'pages':
        #     text = count_pages(sub.text)
        # elif sub.tag == 'volume':
        #     text = count_pages(sub.text)
        else:
            text = sub.text
        if text is not None and len(text) > 0:
            attribs[sub.tag] = attribs.get(sub.tag) + [text]
    return attribs


def parse_all(dblp_path, save_path, include_key=False, include_publtype=False):
    log_msg("PROCESS: Start parsing...")
    f = open(save_path, 'w', encoding='utf8')
    for _, elem in context_iter(dblp_path):
        if elem.tag in all_elements:
            attrib_values = extract_feature(elem, all_features, include_key, include_publtype)
            f.write(str(attrib_values) + '\n')
        clear_element(elem)
    f.close()
    log_msg("FINISHED...")  # load the saved results line by line using json


def parse_entity(dblp_path, save_path, type_name, features=None, save_to_csv=False, include_key=False, include_publtype=False):
    """Parse specific elements according to the given type name and features"""
    log_msg("PROCESS: Start parsing for {}...".format(str(type_name)))
    assert features is not None, "features must be assigned before parsing the dblp dataset"
    results = []
    attrib_count, full_entity, part_entity = {}, 0, 0
    for _, elem in context_iter(dblp_path):
        if elem.tag in type_name:
            attrib_values = extract_feature(elem, features, include_key, include_publtype)  # extract required features
            results.append(attrib_values)  # add record to results array
            for key, value in attrib_values.items():
                attrib_count[key] = attrib_count.get(key, 0) + len(value)
            cnt = sum([1 if len(x) > 0 else 0 for x in list(attrib_values.values())])
            if cnt == len(features):
                full_entity += 1
            else:
                part_entity += 1
        elif elem.tag not in all_elements:
            continue
        clear_element(elem)
    if save_to_csv:
        f = open(save_path, 'w', newline='', encoding='utf8')
        writer = csv.writer(f, delimiter=',')
        writer.writerow(features)  # write title
        for record in results:
            # some features contain multiple values (e.g.: author), concatenate with `::`
            row = ['::'.join(v) for v in list(record.values())]
            writer.writerow(row)
        f.close()
    else:  # default save to json file
        with codecs.open(save_path, mode='w', encoding='utf8', errors='ignore') as f:
            ujson.dump(results, f)
    return full_entity, part_entity, attrib_count

def parse_article(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ['article']
    features = ['title', 'author', 'year', 'journal', 'ee', 'url']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total articles found: {}, articles contain all features: {}, articles contain part of features: {}'
            .format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_inproceedings(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["inproceedings"]
    features = ['title', 'author', 'year', 'crossref', 'booktitle', 'ee', 'url']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total inproceedings found: {}, inproceedings contain all features: {}, inproceedings contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_www(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["www"]
    features = ['title', 'author']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total www found: {}, www contain all features: {}, www contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_phdthesis(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["phdthesis"]
    features = ['title', 'author','school', 'year', 'ee']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total phdthesis found: {}, phdthesis contain all features: {}, phdthesis contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_mastersthesis(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["mastersthesis"]
    features = ['title', 'author','school', 'year', 'ee']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total mastersthesis found: {}, mastersthesis contain all features: {}, mastersthesis contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_incollection(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["inproceedings"]
    features = ['title', 'author', 'year', 'crossref', 'booktitle', 'ee', 'url']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total incollection found: {}, incollection contain all features: {}, incollection contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_proceedings(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["proceedings"]
    features = ['title', 'editor', 'year', 'publisher', 'booktitle', 'volume', 'series', 'ee',  'url', 'isbn']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=False)
    log_msg('Total proceedings found: {}, proceedings contain all features: {}, proceedings contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_book(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ["book"]
    features = ['title', 'editor', 'year', 'publisher', 'booktitle', 'volume', 'series', 'ee',  'url', 'isbn']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=False)
    log_msg('Total books found: {}, books contain all features: {}, books contain part of features: {}'
            .format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_publications(dblp_path, save_path, save_to_csv=False, include_key=False, include_publtype=False):
    type_name = ['article', 'book', 'incollection', 'inproceedings']
    features = ['title', 'year', 'pages']
    info = parse_entity(dblp_path, save_path, type_name, features, save_to_csv=save_to_csv, include_key=include_key, include_publtype=include_publtype)
    log_msg('Total publications found: {}, publications contain all features: {}, publications contain part of '
            'features: {}'.format(info[0] + info[1], info[0], info[1]))
    log_msg("Features information: {}".format(str(info[2])))

def parse_author(dblp_path, save_path, save_to_csv=False):
    type_name = ['author', 'editor']
    log_msg("PROCESS: Start parsing for {}...".format(str(type_name)))
    authors = set()
    for _, elem in context_iter(dblp_path):
        if elem.tag in type_name:
            authors.add((elem.text, elem.attrib['orcid'] if 'orcid' in elem.keys() else ''))
        clear_element(elem)
    if save_to_csv:
        f = open(save_path, 'w', newline='', encoding='utf8')
        writer = csv.writer(f, delimiter=',')
        writer.writerow(('name','orcid'))
        writer.writerows(a for a in list(authors))
        f.close()
    else:
        with open(save_path, 'w', encoding='utf8') as f:
            f.write(ujson.dumps([{'name':a[0], 'orcid':a[1]} for a in list(authors)],indent=2, ensure_ascii=False))
    log_msg("FINISHED...")


def main():
    dblp_path = 'dblp.xml'
    save_path = 'article.json'
    try:
        context_iter(dblp_path)
        log_msg("LOG: Successfully loaded \"{}\".".format(dblp_path))
    except IOError:
        log_msg("ERROR: Failed to load file \"{}\". Please check your XML and DTD files.".format(dblp_path))
        exit()
    parse_article(dblp_path, save_path, save_to_csv=False)
    

if __name__ == '__main__':
    main()
