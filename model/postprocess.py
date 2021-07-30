import numpy as np
import random
import tensorflow as tf


def top_one_result(tmp_list):
    # index_list = sorted(range(len(tmp_list)), key=lambda k: tmp_list[k], reverse=True)
    # print('===================================================')
    # print(index_list)
    # print('===================================================')
    index_list = sorted(range(len(tmp_list)), key=lambda k: tmp_list[k], reverse=True)[:2]
    # print("=================================================")
    # print(index_list)
    # print("=================================================")

    return index_list


def gen_on_keyword(tmp_Vocab, keyword, tmp_list, lookup_table):

    keyword_index = tmp_Vocab.get_idx(keyword)
    index_list = sorted(range(len(tmp_list)), key=lambda k: tmp_list[k], reverse=True)[:3]

    if (float(tmp_list[index_list[0]]) / tmp_list[index_list[1]] > 1.3):
        return index_list[0]
    # keyword_index_2 = tmp_Vocab.get_idx('震')

    # print(np.sum(np.array(lookup_table[keyword_index]) * np.array(lookup_table[keyword_index_2])))

    # similar = 0
    index = 0
    for i in range(len(index_list)):
        if (i == 0):
            # similar = abs(np.sum(np.array(lookup_table[keyword_index]) * np.array(lookup_table[index_list[0]])))
            similar = np.linalg.norm(np.array(lookup_table[keyword_index]) - np.array(lookup_table[index_list[0]]))
        else:
            dist = np.linalg.norm(np.array(lookup_table[keyword_index]) - np.array(lookup_table[index_list[i]]))
            if (dist < similar):
                similar = dist
                index = i

    return index_list[index]


def gen_diversity(tmp_list):
    index_list = sorted(range(len(tmp_list)), key=lambda k: tmp_list[k], reverse=True)[:2]
    index = random.sample(index_list, 1)[0]
    if (float(tmp_list[index_list[0]]) / tmp_list[index_list[1]] > 1.3):
        index = index_list[0]
    return index

def random_pick(some_list,probabilities):
    x = np.random.uniform(0,1)
    cumulative_probability = 0.0
    for item,item_probability in zip(some_list,probabilities):
        cumulative_probability += item_probability
        if x < cumulative_probability:
            break
    return item

def top_n(tmp_list):
    probability = tf.nn.softmax(tmp_list)
    sess = tf.compat.v1.Session()
    probability_np = sess.run(probability)
    index = random_pick(range(len(tmp_list)),probability_np)
    return index