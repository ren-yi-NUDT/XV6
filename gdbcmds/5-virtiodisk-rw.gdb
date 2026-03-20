#virtio_disk_rw():
break virtio_disk.c:281
  commands
    printf "*disk.avail: "
    p *disk.avail
    printf "disk.ops[%d]: ", disk.avail->ring[disk.avail->idx - 1]
    p disk.ops[disk.avail->ring[disk.avail->idx - 1]]
    printf "disk.info[%d]: ", disk.avail->ring[disk.avail->idx - 1]
    p disk.info[disk.avail->ring[disk.avail->idx - 1]]
  end
