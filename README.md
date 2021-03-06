# 084testnet-data

The Qitmeer 0.8.4 testnet data backup for the reward verification.

For block order from `1` to `40651` ( `03cc1f2ffc5a91d877206c03545d60dd5b87a03c491e61362d661286b64b2209` at `2019-12-23_11:59:54_CST`),
we look up every miner address, check if its minded block is valid ( `pow=cuckaroo && txvalid=true && isBlue==1`) and calulate the count of
its all valid block (the `block_count`), the reward for the address is `(block_count%20) * 65` PMEER.


## All rewards & reward ranking 

```bash
$ ./check-block-reward.sh -l
```

##  Check reward details by address

```
$ ./check-block-reward.sh TmmM6mx54w4naqvFdvGHhuVDrYcRgcaKoLp
```

## Build Data by yourself (WARNING : make sure u know what u are doing)

Steps how to generate the date file `` by yourself.

1. run `install.sh` (install the qitmeer 0.8.4.1 (version 44ff547)
2. run `start.sh` from an terminal (start the qitmeer 0.8.4 node with the testdata on the background)
   - if you want to sync the data by yourself, you just wait the qitmeer node show a messge `[INFO ] Your synchronization has been completed.`
   - if you want to use the archive file to restore the `testnet` folder make sure use `install.sh --use-archive` at step (1)
3. run `gen-data.sh -f` from another terminal
4. wait the `gen-data.sh` finished. 
5. `check-block-rewad.sh` with data generated by yourself is ready to use.

**Note:**

1. you can use your `testnet` data directly by copying the your `testnet` folder into the folder to omit the step `1`
2. make sure to install [jq](https://stedolan.github.io/jq/download/) before you run the `gen-data.sh` script
