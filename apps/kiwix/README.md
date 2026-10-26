# Kiwix

This chart serves ZIM files with Kiwix at `https://kiwix.lab.paultibbetts.uk`.
The `kiwix-data` PV is a read-only NFS export from the TrueNAS
`hdd-storage/knowledge/kiwix` dataset.

## Content management

The Kiwix pod cannot write to the share. Put one or more `.zim` files in the
dataset through TrueNAS or another writer, then restart the Kiwix deployment
to have it load newly added files. It finds `.zim` files recursively below
`/data`, so folders may be used to organise the content.

The NFS export must grant the container read and traverse access to every
content directory. The pod runs as the dedicated TrueNAS `kiwix` user and
group (UID/GID `3006`); grant that identity read and execute permissions on
the dataset and its directories.
