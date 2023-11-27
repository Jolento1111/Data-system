from dblp_parser import context_iter, log_msg
from dblp_parser import parse_article, parse_inproceedings, parse_www, parse_phdthesis, parse_mastersthesis, parse_incollection
from dblp_parser import parse_proceedings, parse_book
from dblp_parser import parse_author
from multiprocessing import Process
import time
import math


def mp_parsing():
    dblp_path = '../data/dblp.xml'
    save_path_article = '../data/csv_files/article.csv'
    save_path_inproceedings = '../data/csv_files/inproceedings.csv'
    save_path_www = '../data/csv_files/www.csv'
    save_path_phdthesis = '../data/csv_files/phdthesis.csv'
    save_path_mastersthesis = '../data/csv_files/mastersthesis.csv'
    save_path_incollection = '../data/csv_files/incollection.csv'
    save_path_proceedings = '../data/csv_files/proceedings.csv'
    save_path_book = '../data/csv_files/book.csv'
    save_path_author = '../data/csv_files/authors_orcid.csv'

    try:
        context_iter(dblp_path)
        log_msg("LOG: Successfully loaded \"{}\".".format(dblp_path))
    except IOError:
        log_msg("ERROR: Failed to load file \"{}\". Please check your XML and DTD files.".format(dblp_path))
        exit()

    Targets = [ parse_article, 
                parse_inproceedings, 
                parse_www, 
                parse_phdthesis, 
                parse_mastersthesis, 
                parse_incollection, 
                parse_proceedings, 
                parse_book,
                parse_author]
    Args = [(dblp_path, save_path_article, True, True, True),
            (dblp_path, save_path_inproceedings, True, True, False),
            (dblp_path, save_path_www, True, True, False),
            (dblp_path, save_path_phdthesis, True, True, False),
            (dblp_path, save_path_mastersthesis, True, True, False),
            (dblp_path, save_path_incollection, True, True, False),
            (dblp_path, save_path_proceedings, True, True, True),
            (dblp_path, save_path_book, True, True, False),
            (dblp_path, save_path_author, True)]

    t_start = time.time()
    process_list = []
    for i in range(len(Targets)):
        p = Process(target=Targets[i], args=Args[i])
        p.start()
        process_list.append(p)
    
    for p in process_list:
        p.join()
    t_end = time.time()

    print('Time consumption of multiprocess parsing: {}m{}s'.format(math.floor((t_end-t_start)/60), (t_end-t_start) % 60))
    
if __name__ == '__main__':
    mp_parsing()