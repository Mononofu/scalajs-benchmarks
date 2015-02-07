#!/bin/sh

NAME=$1

echo "
import scala.scalajs.js

object process extends js.Object {
  val argv: js.Array[java.lang.String] = js.native
}

object ${NAME}_js extends js.JSApp {
  def main(): Unit = {
    ${NAME}.main(process.argv.drop(2).toArray)
  }
}

package java {
package io {

// hacked output stream, only writes to stdout
class BufferedOutputStream(out: Any) {
  var buf: Array[Byte] = new Array[Byte](8096)
  var count: Int = 0

  def close(): Unit = {
    flush()
    println()
  }

  def flush(): Unit = {
    if (count > 0) {
      print(new String(buf.take(count).map(_.toChar)))
      count = 0
    }
  }

  def write(b: Array[Byte]): Unit = {
    if (b.length > buf.length - count) {
      flush()
      print(new String(b.map(_.toChar)))
    } else {
      buf = buf.take(count) ++ b
      count += b.length
      if (count == buf.length) {
        flush()
      }
    }
  }

  def write(b: Int): Unit = {
    if (count >= buf.length) {
      print(buf.take(count).map(_.toChar).toString + b.toChar.toString)
      count = 0
    } else {
      buf(count) = b.toByte
      count += 1
      if (count >= buf.length) {
        flush()
      }
    }
  }
}


} // package io
} // package java
"
