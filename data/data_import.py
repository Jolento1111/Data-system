import pandas as pd
from sqlalchemy import create_engine

def csv2sql_dblp(_csv_address, table, database = 'dblp'):
    #  change the connection, username and password to your own
    # engine =create_engine('mysql+pymysql://your_username:your_password@localhost:your_port/dblp')
    engine =create_engine(f'mysql+pymysql://root:MySQL#lwz1009Inhp~m5mgE39W+OISLRe@localhost:3306/{database}')

    print(f'Loading data from {_csv_address}...')
    db = pd.read_csv(_csv_address)
    # db.fillna('',inplace=True)
    print(f'Start importing data...')
    db.to_sql(name = table,con = engine,index = False, if_exists='append', chunksize=1000)

    print(f"Data has been imported to mysql table {database}.{table}")

def read_data(file):
    return 'csv_files/'+file


# before runing this file, you should create a database named 'dblp' in mysql, then execute the given sql files to create tables
# and make sure the tables are empty to avoid duplicate data
if __name__ == "__main__":
    author_path = read_data('authors.csv')
    csv2sql_dblp(author_path,'author')

    article_path = read_data('article.csv')
    csv2sql_dblp(article_path,'article')

    book_path = read_data('book.csv')
    csv2sql_dblp(book_path,'publish')

    proceeding_path = read_data('proceedings.csv')
    csv2sql_dblp(proceeding_path,'publish')

    inproceeding_path = read_data('inproceedings.csv')
    csv2sql_dblp(inproceeding_path,'in_')

    incollection_path = read_data('incollection.csv')
    csv2sql_dblp(incollection_path,'in_')

    master_path = read_data('masterthesis.csv')
    csv2sql_dblp(master_path,'thesis')
    
    phd_path = read_data('phdthesis.csv')
    csv2sql_dblp(phd_path,'thesis')

    www_path = read_data('www.csv')

    author_relation_path = read_data('R_author.csv')
    csv2sql_dblp(author_relation_path,'r_author')

    editor_relation_path = read_data('R_editor.csv')
    csv2sql_dblp(editor_relation_path,'r_editor')

    