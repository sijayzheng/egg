<template>
  <highlightjs
      code="console.log('Hello World');"
      language="js"
  />
</template>

<script>
import 'highlight.js/lib/common';
import hljsVuePlugin from "@highlightjs/vue-plugin";

export default {
  components: {
    highlightjs: hljsVuePlugin.component
  }
}
</script>