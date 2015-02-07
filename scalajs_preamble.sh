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
"
