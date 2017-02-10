#include <ruby.h>
#include <ruby/version.h>

#ifdef WARN_UNUSED_RESULT
#undef WARN_UNUSED_RESULT
#endif

#if RUBY_API_VERSION_CODE >= 20400
#	include "2.4.0/internal.h"
#elif RUBY_API_VERSION_CODE >= 20300
#	include "2.3.0/internal.h"
#elif RUBY_API_VERSION_CODE >= 20200
#	include "2.2.0/internal.h"
#elif RUBY_API_VERSION_CODE >= 20100
#	include "2.1.0/internal.h"
#else
#	include <ruby/backward/classext.h>
#endif
#define RCLASS_SUPER(c) (RCLASS(c)->super)
#define RB_CLEAR_CACHE_BY_CLASS(c) rb_clear_method_cache_by_class(c)


static void unmixin(VALUE self, VALUE mod) {
};

static VALUE rb_m_unmixin(VALUE self, VALUE mod) {
  Check_Type(mod, T_MODULE);

//   printf("self:%x\n", self);
//   printf("mod:%x\n", mod);
  VALUE superklass = RCLASS_SUPER(self);
  VALUE lastklass = self;

  do {
//     printf("------------------------------\n");
//     printf("class:%s\n", rb_obj_classname(superklass));
//     printf("class:%s\n", rb_class2name(superklass));
    if(RB_TYPE_P(superklass, RUBY_T_CLASS) && superklass != self) break;
    if(superklass == mod || RCLASS_M_TBL(superklass) == RCLASS_M_TBL(mod)) {
      RCLASS_SUPER(lastklass) = RCLASS_SUPER(superklass);
      RB_CLEAR_CACHE_BY_CLASS(lastklass);
      break;
    }
	lastklass = superklass;
    superklass = RCLASS_SUPER(superklass);
  } while (superklass);

  return self;
}


void Init_unmixer(void) {
  rb_define_method(rb_cModule, "unmixer_unmixin", RUBY_METHOD_FUNC(rb_m_unmixin), 1);
}
