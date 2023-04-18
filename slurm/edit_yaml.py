import yaml
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--config', type=str, default='SSR/configs/SSR_room0_config.yaml')
parser.add_argument('--jid', type=str)
parser.add_argument('--options', nargs='+', default='')
args = parser.parse_args()


def merge_dicts(a, b):
    '''b += a'''
    b = b.copy()
    for k, v in a.items():
        if isinstance(v, dict) and k in b:
            b[k] = merge_dicts(v, b[k])
        else:
            b[k] = v
    return b

with open(args.config) as f:
    y = yaml.safe_load(f)

    if args.options:  # xxx.xx.x=yyy zzz=www
        update = {}
        for option in args.options:  # xxx.xx.x=yyy
            u = update
            key_list, v = option.split('=')
            key_list = key_list.split('.')
            for subkey in key_list[:-1]:
                u = u.setdefault(subkey, {})
            subkey = key_list[-1]
            u[subkey] = v
        y = merge_dicts(update, y)
        p_out = f'SSR/configs/tmp/{args.jid}.yaml'
        with open(p_out, 'w') as f:
            yaml.dump(y, f, default_flow_style=False, sort_keys=False)
        print(p_out)
