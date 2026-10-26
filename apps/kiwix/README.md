# Kiwix

This chart serves ZIM files with Kiwix at `https://kiwix.lab.paultibbetts.uk`.
The `kiwix-data` PV is a read-only NFS export from the TrueNAS
`hdd-storage/knowledge/kiwix` dataset.

## Content management

The Kiwix pod cannot write to the share. Put one or more `.zim` files in the
dataset through TrueNAS or another writer, then restart the Kiwix deployment
to have it load newly added files. The server starts with `/data`, so it
automatically serves ZIM files in the dataset and its subdirectories.
