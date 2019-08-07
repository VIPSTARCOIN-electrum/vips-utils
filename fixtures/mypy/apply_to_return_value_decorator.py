from typing import (
    List,
    Tuple,
)
from vips_utils import (
    apply_to_return_value
)

def wrap_as_list(value: int) -> List[int]:
    return [value]

@apply_to_return_value(wrap_as_list)
def return_value() -> int:
    return 1

x = return_value()
reveal_type(x)
